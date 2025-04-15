class Token 
{
  final String accessToken;
  final String refreshToken;
  
  Token
  ({
    required this.accessToken,
    required this.refreshToken,
  });

  @override
  String toString() 
  {
    return 'Token[accesToken: $accessToken, refreshToken: $refreshToken]';
  }
}
