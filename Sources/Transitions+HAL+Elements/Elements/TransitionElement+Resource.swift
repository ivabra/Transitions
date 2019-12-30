import Transitions_Core
import Transitions_RequestBuilder
import Transitions_HAL_Models
import Transitions_URLStrategy

public extension TransitionElement where TransitionResult: Resource {

  func transitionThrough(link: TransitionResult.LinkKey) -> ResourceTransitionElement<TransitionResult.LinkKey, TransitionResult, Self, FirstLinkTransitionURLStrategy, JustURLRequestBuilder> {
     ResourceTransitionElement(linkKey: link,
                               parentElement: self,
                               urlStrategy: FirstLinkTransitionURLStrategy.strategy,
                               requestBuilder: JustURLRequestBuilder.builder
     )
   }

}
