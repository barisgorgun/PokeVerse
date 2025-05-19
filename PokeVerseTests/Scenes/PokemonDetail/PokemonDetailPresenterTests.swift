//
//  PokemonDetailPresenterTests.swift
//  PokeVerseTests
//
//  Created by Gorgun, Baris on 18.05.2025.
//

import XCTest

@testable import PokeVerse

final class PokemonDetailPresenterTests: XCTestCase {

    private var presenter: PokemonDetailPresenter!
    private var view: MockDetailView!
    private var interactor: MockDetailInteractor!

    override func setUp() {
        super.setUp()

        view = MockDetailView()
        interactor = MockDetailInteractor()
        presenter = PokemonDetailPresenter(view: view, interactor: interactor)
    }

    override func tearDown() {
        view = nil
        interactor = nil

        super.tearDown()
    }

    func test_loadData_triggersFetch_andUpdatesViewOnSuccess() {
        // Given
        XCTAssertFalse(interactor.fetchDataCalled)
        let expectation = XCTestExpectation(description: "loadData called")

        interactor.onFetchDataCalled = {
            expectation.fulfill()
        }

        // When
        presenter.loadData()

        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(interactor.fetchDataCalled)
    }

    func test_loadData_showsAlertOnFailure() {
        // Given
        let error = NetworkError.contentEmptyData
        let expectedMessage = error.localizedDescription

        // When
        presenter.handleOutput(.showAlert(error))

        // Then
        XCTAssertEqual(view.outputs.count, 1)
        if case let .showAlert(alert) = view.outputs.first {
            XCTAssertEqual(alert.message, expectedMessage)
        } else {
            XCTFail("Expected .showAlert output")
        }
    }

    func test_selectedControllerTapped_withIndex0_showsAboutView() {
        // When
        presenter.selectedControllerTapped(at: .zero)

        // Then
        if case let .showInfoView(receivedType) = view.outputs.first {
            XCTAssertEqual(receivedType, .about)
        }
    }

    func test_selectedControllerTapped_withIndex1_showsAboutView() {
        // When
        presenter.selectedControllerTapped(at: 1)

        // Then
        if case let .showInfoView(receivedType) = view.outputs.first {
            XCTAssertEqual(receivedType, .stats)
        }
    }

    func test_selectedControllerTapped_withIndex2_showsAboutView() {
        // When
        presenter.selectedControllerTapped(at: 2)

        // Then
        if case let .showInfoView(receivedType) = view.outputs.first {
            XCTAssertEqual(receivedType, .evolution)
        }
    }

    func test_selectedControllerTapped_withInvalidIndex_doesNotCrash() {
        // When
        presenter.selectedControllerTapped(at: 3)

        // Then
        XCTAssertTrue(view.outputs.isEmpty, "Unexpected output sent for invalid index \(3)")
    }

    func test_selectedControllerTapped_withMaxInt_handlesGracefully() {
        // When
        presenter.selectedControllerTapped(at: Int.max)

        // Then
        XCTAssertTrue(view.outputs.isEmpty, "No output should be sent for invalid index")
        XCTAssertFalse(interactor.fetchDataCalled, "Interactor should not be triggered")

    }

    func test_handleOutput_showAlert_convertsErrorToUserMessage() {
        let testError = NetworkError.contentEmptyData
        let expectedMessage = testError.localizedDescription

        // When
        presenter.handleOutput(.showAlert(testError))

        // Then
        XCTAssertEqual(view.outputs.count, 1, "Exactly 1 output should be sent")

        if case let .showAlert(alert) = view.outputs.first {
            XCTAssertEqual(alert.message, expectedMessage, "Error message should be propagated correctly")
            XCTAssertEqual(alert.actions.count, 1, "Default action should be added")
            XCTAssertEqual(alert.actions.first?.title, "action_1".localized(), "Default action title should be correct")
        } else {
            XCTFail("Expected showAlert output type")
        }
    }
}

// MARK: - PokemonDetailViewProtocol

private final class MockDetailView: PokemonDetailViewProtocol {
    var outputs: [PokemonDetailPresenterOutput] = []

    func handleOutput(_ output: PokemonDetailPresenterOutput) {
        outputs.append(output)
    }
}

// MARK: - PokemonDetailInteractorProtocol

private final class MockDetailInteractor: PokemonDetailInteractorProtocol {
    var delegate: (any PokemonDetailInteractorDelegate)?
    var fetchDataCalled = false
    var onFetchDataCalled: (() -> Void)?

    func fetchData() async {
        fetchDataCalled = true
        onFetchDataCalled?()
    }
}
