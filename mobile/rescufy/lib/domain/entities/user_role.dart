enum UserRole {
  user,
  paramedic,
  admin;

  bool get isParamedic => this == UserRole.paramedic;
  bool get isUser => this == UserRole.user;
  bool get isAdmin => this == UserRole.admin;

  bool get canLoginFromMobile {
    return this == UserRole.user || this == UserRole.paramedic;
  }
}
