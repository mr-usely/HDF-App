class Servers {
  static final port = 8012;
  static final serverURL = 'http://www.universalleaf.com.ph:$port';
  Servers._();
  static final Servers svr = Servers._();

  static Servers get ins => svr;
}
