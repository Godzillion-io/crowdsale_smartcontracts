/**
*contract name : ReentryProtected
*/
contract ReentryProtected{
    /*The reentry protection state mutex.*/
    bool __reMutex;

    /**
    *This modifier can be used on functions with external calls to
    *prevent reentry attacks.
    *Constraints:
    *Protected functions must have only one point of exit.
    *Protected functions cannot use the `return` keyword
    *Protected functions return values must be through return parameters.
    */
    modifier preventReentry() {
        require(!__reMutex);
        __reMutex = true;
        _;
        delete __reMutex;
        return;
    }

    /**
    *This modifier can be applied to public access state mutation functions
    *to protect against reentry if a `preventReentry` function has already
    *set the mutex. This prevents the contract from being reenter under a
    *different memory context which can break state variable integrity.
    */
    modifier noReentry() {
        require(!__reMutex);
        _;
    }
}