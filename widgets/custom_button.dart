CustomButton(
  text = 'S\'inscrire',
  onPressed = () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PhoneSignInScreen()),
    );
  },
)
