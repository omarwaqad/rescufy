enum UserRole {
  user,
  ambulanceDriver,
  paramedic;

  bool get isParamedic => this == UserRole.paramedic;
  bool get isAmbulanceDriver => this == UserRole.ambulanceDriver;
  bool get isUser => this == UserRole.user;

  bool get canLoginFromMobile {
    return true;
  }
}
