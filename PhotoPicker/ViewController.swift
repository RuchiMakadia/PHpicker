//
//  ViewController.swift
//  PhotoPicker
//
//  Created by eheuristic on 01/07/20.
//

import UIKit
import PhotosUI

class ViewController: UIViewController {
    
    @IBOutlet weak var img_view: UIImageView!{
        didSet {
            img_view.contentMode = .scaleAspectFit
        }
    }
    @IBOutlet weak var btn_open: UIButton!
    
    private var itemProviders = [NSItemProvider]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func btn_open_picker_select(_ sender: UIButton) {
        presentPicker(filter: PHPickerFilter.images)
    }
    
    private func presentPicker(filter: PHPickerFilter) {
        var configuration = PHPickerConfiguration()
        configuration.filter = filter
        configuration.selectionLimit = 0
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
}

extension ViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        
        itemProviders = results.map(\.itemProvider)
        let itemProvidersIterator = itemProviders.first
        if ((itemProvidersIterator?.canLoadObject(ofClass: UIImage.self)) != nil) {
            itemProvidersIterator!.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                DispatchQueue.main.async {
                    if let image = image as? UIImage {
                        self?.img_view.image = image
                    } else {
                        print("Couldn't load image with error: \(error?.localizedDescription ?? "unknown error")")
                    }
                }
            }
        }
        else {
            print("Unsupported item provider: \(itemProvidersIterator)")
        }
    }
}
