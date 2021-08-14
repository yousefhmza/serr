abstract class AuthStates{}

class AuthInitialState extends AuthStates{}

class AuthScreenSeenState extends AuthStates{}

class AuthPasswordVisibilityState extends AuthStates{}

class AuthSetAuthModeState extends AuthStates{}


// register states

class AuthRegisterLoadingState extends AuthStates{}

class AuthRegisterSuccessState extends AuthStates{}

class AuthRegisterFailureState extends AuthStates{}

// login states

class AuthLoginLoadingState extends AuthStates{}

class AuthLoginSuccessState extends AuthStates{}

class AuthLoginFailureState extends AuthStates{}

//google auth states

class AuthGoogleAuthLoadingState extends AuthStates{}

class AuthGoogleAuthSuccessState extends AuthStates{}

class AuthGoogleAuthFailureState extends AuthStates{}

// logout states

class AuthLogoutLoadingState extends AuthStates{}

class AuthLogoutSuccessState extends AuthStates{}

class AuthLogoutFailureState extends AuthStates{}
