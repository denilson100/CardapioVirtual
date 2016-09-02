//
//  EmailViewController.swift
//  CardapioVirtual
//
//  Created by Denilson Monteiro on 02/09/16.
//  Copyright © 2016 Mobile10. All rights reserved.
//

import Foundation
import UIKit

import FirebaseAuth

@objc(EmailViewController)
class EmailViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func didTapEmailLogin(sender: AnyObject) {
        if let email = self.emailField.text, password = self.passwordField.text {
            showSpinner({
                // [START headless_email_auth]
                FIRAuth.auth()?.signInWithEmail(email, password: password) { (user, error) in
                    // [START_EXCLUDE]
                    self.hideSpinner({
                        if let error = error {
                            self.showMessagePrompt(error.localizedDescription)
                            return
                        }
                        self.navigationController!.popViewControllerAnimated(true)
                    })
                    // [END_EXCLUDE]
                }
                // [END headless_email_auth]
            })
        } else {
            self.showMessagePrompt("email/password can't be empty")
        }
    }
    
    /** @fn requestPasswordReset
     @brief Requests a "password reset" email be sent.
     */
    @IBAction func didRequestPasswordReset(sender: AnyObject) {
        showTextInputPromptWithMessage("Email:") { (userPressedOK, userInput) in
            if let userInput = userInput {
                self.showSpinner({
                    // [START password_reset]
                    FIRAuth.auth()?.sendPasswordResetWithEmail(userInput) { (error) in
                        // [START_EXCLUDE]
                        self.hideSpinner({
                            if let error = error {
                                self.showMessagePrompt(error.localizedDescription)
                                return
                            }
                            self.showMessagePrompt("Sent")
                        })
                        // [END_EXCLUDE]
                    }
                    // [END password_reset]
                })
            }
        }
    }
    
    /** @fn getProvidersForEmail
     @brief Prompts the user for an email address, calls @c FIRAuth.getProvidersForEmail:callback:
     and displays the result.
     */
    @IBAction func didGetProvidersForEmail(sender: AnyObject) {
        showTextInputPromptWithMessage("Email:") { (userPressedOK, email) in
            if let email = email {
                self.showSpinner({
                    // [START get_providers]
                    FIRAuth.auth()?.fetchProvidersForEmail(email) { (providers, error) in
                        // [START_EXCLUDE]
                        self.hideSpinner({
                            if let error = error {
                                self.showMessagePrompt(error.localizedDescription)
                                return
                            }
                            self.showMessagePrompt(providers!.joinWithSeparator(", "))
                        })
                        // [END_EXCLUDE]
                    }
                    // [END get_providers]
                })
            } else {
                self.showMessagePrompt("email can't be empty")
            }
        }
    }
    
    @IBAction func didCreateAccount(sender: AnyObject) {
        showTextInputPromptWithMessage("Email:") { (userPressedOK, email) in
            if let email = email {
                self.showTextInputPromptWithMessage("Password:") { (userPressedOK, password) in
                    if let password = password {
                        self.showSpinner({
                            // [START create_user]
                            FIRAuth.auth()?.createUserWithEmail(email, password: password) { (user, error) in
                                // [START_EXCLUDE]
                                self.hideSpinner({
                                    if let error = error {
                                        self.showMessagePrompt(error.localizedDescription)
                                        return
                                    }
                                    print("\(user!.email!) created")
                                    self.navigationController!.popViewControllerAnimated(true)
                                })
                                // [END_EXCLUDE]
                            }
                            // [END create_user]
                        })
                    } else {
                        self.showMessagePrompt("password can't be empty")
                    }
                }
            } else {
                self.showMessagePrompt("email can't be empty")
            }
        }
    }
}
