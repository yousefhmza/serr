abstract class HomeStates {}

class HomeInitialState extends HomeStates {}

class HomeSetBNBIndexState extends HomeStates {}

class HomeSetBsState extends HomeStates {}

// search states

class HomeSearchLoadingState extends HomeStates {}

class HomeSearchSuccessState extends HomeStates {}

class HomeSearchFailureState extends HomeStates {}

//get searched user data states

class HomeGetSearchedUserDataLoadingState extends HomeStates {}

class HomeGetSearchedUserDataSuccessState extends HomeStates {}

class HomeGetSearchedUserDataFailureState extends HomeStates {}

// send message states

class HomeSendMessageLoadingState extends HomeStates {}

class HomeSendMessageSuccessState extends HomeStates {
  final String message;

  HomeSendMessageSuccessState(this.message);
}

class HomeSendMessageFailureState extends HomeStates {}

// comment states

class HomeCommentLoadingState extends HomeStates {}

class HomeCommentSuccessState extends HomeStates {}

class HomeCommentFailureState extends HomeStates {}

// get user messages states

class HomeGetMessagesLoadingState extends HomeStates {}

class HomeGetMessagesSuccessState extends HomeStates {}

class HomeGetMessagesFailureState extends HomeStates {}

// get user sent messages states

class HomeGetSentMessagesLoadingState extends HomeStates {}

class HomeGetSentMessagesSuccessState extends HomeStates {}

class HomeGetSentMessagesFailureState extends HomeStates {}

//get user fav messages

class HomeGetFavMessagesLoadingState extends HomeStates {}

class HomeGetFavMessagesSuccessState extends HomeStates {}

class HomeGetFavMessagesFailureState extends HomeStates {}

// get public messages states (for either user or searched profile)

class HomeGetPublicMessagesLoadingState extends HomeStates {}

class HomeGetPublicMessagesSuccessState extends HomeStates {}

class HomeGetPublicMessagesFailureState extends HomeStates {}

// patch fav messages states

class HomeSetFavLoadingState extends HomeStates {}

class HomeSetFavSuccessState extends HomeStates {}

class HomeSetFavFailureState extends HomeStates {}

// patch public messages states

class HomeSetPublicLoadingState extends HomeStates {}

class HomeSetPublicSuccessState extends HomeStates {}

class HomeSetPublicFailureState extends HomeStates {}

// deleting a message states

class HomeDeleteMessageLoadingState extends HomeStates {}

class HomeDeleteMessageSuccessState extends HomeStates {}

class HomeDeleteMessageFailureState extends HomeStates {}

//update user data states

class HomeUpdateDataLoadingState extends HomeStates {}

class HomeUpdateDataSuccessState extends HomeStates {
  final String message;

  HomeUpdateDataSuccessState(this.message);
}

class HomeUpdateDataFailureState extends HomeStates {}

// get image states

class HomeGetImageLoadingState extends HomeStates {}

class HomeGetImageSuccessState extends HomeStates {}

class HomeGetImageFailureState extends HomeStates {}
