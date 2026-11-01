//
//  SpeechToTextService.swift
//  DataLayer
//

import AVFoundation
import Foundation
import Speech

@MainActor
public final class SpeechToTextService: ObservableObject {
    @Published public var isRecording = false

    private let audioEngine = AVAudioEngine()
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "de-DE"))

    public init() {}

    public func requestPermissions() async {
        _ = await withCheckedContinuation { (cont: CheckedContinuation<Bool, Never>) in
            SFSpeechRecognizer.requestAuthorization { status in
                cont.resume(returning: status == .authorized)
            }
        }
        _ = await withCheckedContinuation { (cont: CheckedContinuation<Bool, Never>) in
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                cont.resume(returning: granted)
            }
        }
    }

    public func start(
        into onPartial: @escaping (String) -> Void,
        onFinal: @escaping (String) -> Void
    ) {
        guard !isRecording else {
            return
        }
        guard let recognizer, recognizer.isAvailable else {
            return
        }

        // Clean up
        stop()

        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.record, mode: .measurement, options: [.duckOthers])
            try session.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            return
        }

        let req = SFSpeechAudioBufferRecognitionRequest()
        req.shouldReportPartialResults = true
        request = req

        let inputNode = audioEngine.inputNode
        let format = inputNode.outputFormat(forBus: 0)
        inputNode.removeTap(onBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { buffer, _ in
            req.append(buffer)
        }

        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            stop()
            return
        }

        isRecording = true

        recognitionTask = recognizer.recognitionTask(with: req) { [weak self] result, error in
            guard let self else {
                return
            }

            if let result {
                let text = result.bestTranscription.formattedString
                onPartial(text)

                if result.isFinal {
                    onFinal(text)
                    self.stop()
                }
            }

            if error != nil {
                self.stop()
            }
        }
    }

    public func stop() {
        if audioEngine.isRunning {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
        }
        request?.endAudio()
        recognitionTask?.cancel()

        request = nil
        recognitionTask = nil

        isRecording = false

        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
    }
}
