internal func funcNotImplemented(_ functionName: StaticString = #function) -> Never {
  fatalError("\(functionName) is not implemented.")
}
