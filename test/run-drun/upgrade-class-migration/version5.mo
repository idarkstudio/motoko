import Prim "mo:prim";

// drops the migration expression from version4.mo
actor class C() {

   Prim.debugPrint("Version 5");

   stable var zero : Nat = Prim.trap "unreachable"; // inherited
   assert zero == 0;

   stable var four : [var (Text, Nat, Bool)] = [var];

   public func check(): async() {
     Prim.debugPrint(debug_show{zero; four});
   }
};
