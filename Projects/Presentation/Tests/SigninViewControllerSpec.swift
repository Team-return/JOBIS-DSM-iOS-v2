import Quick
import Nimble
import RxSwift
import UIKit
import Domain
import DesignSystem
@testable import Presentation

final class SigninViewControllerSpec: QuickSpec {
    override func spec() {
        var sut: SigninViewController!
        var reactor: SigninReactor!

        describe("로그인 화면") {
            beforeEach {
                waitUntil { done in
                    DispatchQueue.main.async {
                        reactor = createTestSigninReactor()
                        sut = SigninViewController(reactor)
                        _ = sut.view
                        sut.view.layoutIfNeeded()
                        done()
                    }
                }
            }

            afterEach {
                sut = nil
                reactor = nil
            }

            it("필수 UI 요소들이 존재해야 함") {
                waitUntil { done in
                    DispatchQueue.main.async {
                        let textFields = sut.view.subviews.compactMap { $0 as? JobisTextField }
                        let signinButton = sut.view.subviews.compactMap { $0 as? JobisButton }.first
                        let forgetPasswordButton = sut.view.subviews.compactMap { $0 as? ForgetPasswordButton }.first

                        expect(textFields.count).to(beGreaterThanOrEqualTo(2))
                        expect(signinButton).toNot(beNil())
                        expect(forgetPasswordButton).toNot(beNil())
                        done()
                    }
                }
            }

            it("비밀번호 필드가 secure 입력이어야 함") {
                waitUntil { done in
                    DispatchQueue.main.async {
                        let textFields = sut.view.subviews.compactMap { $0 as? JobisTextField }
                        let passwordTextField = textFields.count > 1 ? textFields[1] : nil

                        expect(passwordTextField?.textField.isSecureTextEntry).to(beTrue())
                        done()
                    }
                }
            }

            it("Reactor와 상태 바인딩이 되어야 함") {
                expect(reactor.currentState.email).to(equal(""))
                expect(reactor.currentState.password).to(equal(""))
                expect(reactor.currentState.emailError).to(equal(""))
                expect(reactor.currentState.passwordError).to(equal(""))
            }

            it("비밀번호 필드에서 리턴 키 누르면 로그인되어야 함") {
                waitUntil { done in
                    DispatchQueue.main.async {
                        let textFields = sut.view.subviews.compactMap { $0 as? JobisTextField }
                        expect(textFields.count).to(beGreaterThanOrEqualTo(2))

                        let passwordTextField = textFields[1]
                        let shouldReturn = sut.textFieldShouldReturn(passwordTextField.textField)
                        expect(shouldReturn).to(beTrue())
                        done()
                    }
                }
            }

            it("비밀번호 필드의 delegate가 설정되어야 함") {
                waitUntil { done in
                    DispatchQueue.main.async {
                        let textFields = sut.view.subviews.compactMap { $0 as? JobisTextField }
                        let passwordTextField = textFields.count > 1 ? textFields[1] : nil

                        expect(passwordTextField?.textField.delegate).toNot(beNil())
                        done()
                    }
                }
            }
        }
    }
}
