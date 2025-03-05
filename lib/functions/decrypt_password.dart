String encryptString(String text, {int shift = 7}) {
  String encryptedText = "";

  for (int i = 0; i < text.length; i++) {
    int charCode = text.codeUnitAt(i);
    int encryptedCharCode = charCode + shift;
    encryptedText += String.fromCharCode(encryptedCharCode);
  }

  return encryptedText;
}
