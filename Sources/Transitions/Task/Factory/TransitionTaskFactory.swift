public protocol TransitionTaskFactory {
  func task<Element>(for path: Element) -> TransitionTask<Element.TransitionResult> where Element: TransitionElement
}
