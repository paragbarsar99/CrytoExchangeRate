//
//  MainView.swift
//  BitCoinTracker
//
//  Created by parag on 06/01/25.
//

import UIKit

class MainView:UIView{

    // MARK: - Initializer
      override init(frame: CGRect) {
          super.init(frame: frame)
          setupUI()
          setupConstraints()
      }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupConstraints()
    }
    
    
    var currentyRowContainer: UIStackView = {
        let createHstack = UIStackView();
        createHstack.axis = .horizontal;
        createHstack.spacing = 10
        createHstack.distribution = .fill;
        createHstack.backgroundColor  = .gray;
 
        createHstack.translatesAutoresizingMaskIntoConstraints = false
        return createHstack
    }()
    

    lazy var currency:UILabel = {
        let t = UILabel();
        t.font =  UIFont.systemFont(ofSize: 28,weight: .semibold)
        t.textColor = .systemBackground
        t.translatesAutoresizingMaskIntoConstraints = false;
        t.text = "INR"
        return t
    }();
    
    lazy var value :UILabel = {
        let t = UILabel();
        t.text = "0.0"
     
        t.font = UIFont.systemFont(ofSize: 22,weight: .bold)
        t.tintColor = .systemBackground;
        t.translatesAutoresizingMaskIntoConstraints = false;
        return t
    }()
    lazy var header :UILabel = {
        let t = UILabel();
        t.text = "Byte Coin"
        t.font = UIFont.systemFont(ofSize: 42,weight: .semibold);
        t.textColor = .systemBackground
        t.translatesAutoresizingMaskIntoConstraints = false;
        return t
    }()

    
   private var buttonConfig:UIButton.Configuration{
        var buttonConfig  = UIButton.Configuration.plain()
        buttonConfig.contentInsets  = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        return buttonConfig
    }

    
    lazy var bitCoinIcon:UIImageView = {
        let imgView = UIImageView();
        imgView.image = SystemUIImage(src: "bitcoinsign.square.fill",config: UIImage.SymbolConfiguration(pointSize: 42))
        imgView.contentMode = .scaleAspectFill;
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.tintColor = .systemBackground
        return imgView
    }();
    
    
   lazy var picker:UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        
        return picker
    }()

    
    func ImageView()-> UIImageView{
        let imgView = UIImageView();
        imgView.contentMode = .scaleAspectFill;
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }
    
    func SystemUIImage(src:String?,config:UIImage.Configuration?) -> UIImage? {
        guard let imgSource = src else {
            return nil
        }
           
        let img =  UIImage(systemName: imgSource, withConfiguration: config)
        return img
           
    }
    
    func resizeImage(named imageName: String, to size: CGSize) -> UIImage? {
        guard let image = UIImage(named: imageName) else {
            return nil
        }
        
        let renderer = UIGraphicsImageRenderer(size: size)
        let resizedImage = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
        
        return resizedImage
    }

    
    private func setupUI() {
        addSubview(header)
        addSubview(currentyRowContainer)
        addSubview(picker)
        backgroundColor = UIColor(hex: "#16C47F")
        
        currentyRowContainer.addArrangedSubview(bitCoinIcon)
        currentyRowContainer.addArrangedSubview(value)
        currentyRowContainer.addArrangedSubview(currency)
        currentyRowContainer.backgroundColor = UIColor(hex:"#56D8A7")
        currentyRowContainer.layoutMargins = UIEdgeInsets(top: 7, left: 14, bottom: 7, right: 14)
        currentyRowContainer.isLayoutMarginsRelativeArrangement = true
        currentyRowContainer.distribution = .fill;
        currentyRowContainer.alignment = .center
        currentyRowContainer.spacing = 20
        currentyRowContainer.layer.cornerRadius = 30;
        currentyRowContainer.layer.masksToBounds = true
    }
    
    private func setupConstraints(){
        NSLayoutConstraint.activate([
            header.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,constant: 20),
            header.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            currentyRowContainer.topAnchor.constraint(equalTo: header.bottomAnchor,constant: 20),
            currentyRowContainer.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    
        NSLayoutConstraint.activate([
            picker.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            picker.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 10),
            picker.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -10)
        ])
        
    }
    
    
}


