import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.Common
import qs.Services

Variants {
    model: Quickshell.screens

    PanelWindow {
        id: warmupWindow
        required property var modelData

        property int activeGeneration: 0
        property bool waitingForFrame: false
        property bool grabInProgress: false

        screen: modelData
        visible: true
        color: "transparent"
        implicitWidth: 1
        implicitHeight: 1

        anchors {
            right: true
            bottom: true
        }

        exclusiveZone: 0
        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Background
        WlrLayershell.namespace: "clavis-lock-screencopy-warmup"

        mask: Region {}

        function captureSize() {
            const source = warmupCapture.sourceSize;
            return Qt.size(Math.max(1, source.width || warmupCapture.width || modelData.width || 1),
                           Math.max(1, source.height || warmupCapture.height || modelData.height || 1));
        }

        function finishWithoutSnapshot(snapshotGeneration) {
            waitingForFrame = false;
            grabInProgress = false;
            grabTimer.stop();
            warmupCapture.captureSource = null;
            LockSnapshot.setSnapshot(modelData.name || "", "", null, snapshotGeneration);
        }

        function grabSnapshot() {
            if (!waitingForFrame || grabInProgress || !warmupCapture.hasContent)
                return;

            const snapshotGeneration = activeGeneration;
            grabInProgress = true;
            snapshotTimeout.stop();

            warmupCapture.grabToImage(result => {
                if (snapshotGeneration !== activeGeneration)
                    return;

                waitingForFrame = false;
                grabInProgress = false;
                grabTimer.stop();
                warmupCapture.captureSource = null;

                if (result)
                    LockSnapshot.setSnapshot(modelData.name || "", result.url, result, snapshotGeneration);
                else
                    LockSnapshot.setSnapshot(modelData.name || "", "", null, snapshotGeneration);
            }, captureSize());
        }

        // Use the wallpaper as the lock backdrop instead of a live screencopy.
        //
        // The screencopy path is unsafe here: on Intel Xe2 the dmabuf import of
        // a 2880x1800 frame can outlast the 120 ms snapshotTimeout, and the
        // timeout handler clears captureSource while the capture is still in
        // flight. That segfaults the Wayland client *before* the session lock
        // is committed, so the compositor never locks and the session is left
        // silently unlocked -- observed once in four attempts.
        //
        // Reporting a URL synchronously keeps the LockSnapshot pending-count
        // protocol intact, so the lock always engages.
        function startSnapshot(snapshotGeneration) {
            activeGeneration = snapshotGeneration;
            waitingForFrame = false;
            grabInProgress = false;
            grabTimer.stop();
            snapshotTimeout.stop();
            recaptureTimer.stop();

            const wallpaper = WallpaperService.currentWallpaper || "";
            const url = (wallpaper !== "" && !wallpaper.startsWith("#"))
                ? Paths.fileUrl(wallpaper) : "";
            LockSnapshot.setSnapshot(modelData.name || "", url, null, snapshotGeneration);
        }

        Connections {
            target: LockSnapshot

            function onPrepareRequested(snapshotGeneration) {
                warmupWindow.startSnapshot(snapshotGeneration);
            }
        }

        Timer {
            id: recaptureTimer
            interval: 0
            repeat: false

            onTriggered: {
                if (!warmupWindow.waitingForFrame)
                    return;

                warmupCapture.captureSource = warmupWindow.screen;
            }
        }

        Timer {
            id: snapshotTimeout
            interval: 120
            repeat: false
            onTriggered: warmupWindow.finishWithoutSnapshot(warmupWindow.activeGeneration)
        }

        Timer {
            id: grabTimer
            interval: 0
            repeat: false
            onTriggered: warmupWindow.grabSnapshot()
        }

        ScreencopyView {
            id: warmupCapture
            readonly property bool sourceReady: sourceSize.width > 0 && sourceSize.height > 0

            width: Math.max(1, sourceReady ? sourceSize.width : (warmupWindow.width || modelData.width || 1))
            height: Math.max(1, sourceReady ? sourceSize.height : (warmupWindow.height || modelData.height || 1))
            captureSource: null
            live: false
            paintCursor: false
            visible: warmupWindow.waitingForFrame || warmupWindow.grabInProgress

            onHasContentChanged: {
                if (hasContent)
                    grabTimer.restart();
            }
        }
    }
}
