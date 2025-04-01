import Prim "mo:prim";

actor {
    stable var firstValue = 0;
    stable var secondValue = 0;

    public func increase() : async () {
        firstValue += 1;
        secondValue += 1;
    };

    public func show() : async () {
        Prim.debugPrint("firstValue=" # debug_show (firstValue));
        Prim.debugPrint("secondValue=" # debug_show (secondValue));
    };
};
