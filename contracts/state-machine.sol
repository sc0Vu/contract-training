contract StateMachine {
    enum Stages {
        AcceptingBlindedBids,
        RevealBids,
        AnotherStage,
        AreWeDoneYet,
        Finished
    }

    // This is the current stage.
    Stages public stage = Stages.AcceptingBlindedBids;

    uint public creationTime = now;

    modifier atStage(Stages _stage) {
        if (stage != _stage) throw;
        _;
    }

    function nextStage() internal {
        stage = Stages(uint(stage) + 1);
    }

    // Perform timed transitions. Be sure to mention
    // this modifier first, otherwise the guards
    // will not take the new stage into account.
    modifier timedTransitions() {
        if (stage == Stages.AcceptingBlindedBids &&
                    now >= creationTime + 10 days)
            nextStage();
        if (stage == Stages.RevealBids &&
                now >= creationTime + 12 days)
            nextStage();
        // The other stages transition by transaction
        _;
    }

    // Order of the modifiers matters here!
    function bid()
        timedTransitions
        atStage(Stages.AcceptingBlindedBids) {
        // We will not implement that here
    }

    function reveal()
        timedTransitions
        atStage(Stages.RevealBids) {
    }

    // This modifier goes to the next stage
    // after the function is done.
    // If you use `return` in the function,
    // `nextStage` will not be called
    // automatically.
    modifier transitionNext() {
        _;
        nextStage();
    }

    function g()
        timedTransitions
        atStage(Stages.AnotherStage)
        transitionNext {
        // If you want to use `return` here,
        // you have to call `nextStage()` manually.
    }

    function h()
        timedTransitions
        atStage(Stages.AreWeDoneYet)
        transitionNext {
    }

    function i()
        timedTransitions
        atStage(Stages.Finished) {
    }
}
