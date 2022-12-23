class SignInWithEmailAndPass {
  final String message;

  const SignInWithEmailAndPass([this.message="An Unknown error occurred."]);

  factory SignInWithEmailAndPass.code(String code){
     switch(code){
       case 'weak-password':return SignInWithEmailAndPass('Please enter a strong password');
       case 'invalid-email':return SignInWithEmailAndPass('Please enter the company email');
       case 'email-already-in-use':return SignInWithEmailAndPass('Please enter the new email');
       case 'operation-not-allowed':return SignInWithEmailAndPass('Operation is not allowed.');
       case 'user-disable':return SignInWithEmailAndPass('This user has been disabled');
       default: return SignInWithEmailAndPass();
     }
  }
}