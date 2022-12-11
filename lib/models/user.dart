class User {
    User({
        this.userId,
        this.userPhone,
        this.userEmail,
        this.userName,
        this.userCountry,
        this.userCity,
        this.userCityName,
        this.userCountryName,
        this.userPhoto,
        this.userShow,
        this.userType,
        this.userFashNumber,
        this.userFashAdress,
    });

    String userId;
    String userPhone;
    String userEmail;
    String userName;
    String userCountry;
    String userCity;
    String userCityName;
    String userCountryName;
    String userPhoto;
    String userShow;
    String userType;
    String userFashNumber;
    String userFashAdress;

    factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json["user_id"],
        userPhone: json["user_phone"],
        userEmail: json["user_email"],
        userName: json["user_name"],
        userCountry: json["user_country"],
        userCity: json["user_city"],
        userCityName: json["user_city_name"],
        userCountryName: json["user_country_name"],
        userPhoto: json["user_photo"],
        userShow: json["user_show"],
        userType: json["user_type"],
        userFashNumber: json["user_fash_number"],
        userFashAdress: json["user_fash_adress"],
    );

    Map<String, dynamic> toJson() => {
        "user_id": userId,
        "user_phone": userPhone,
        "user_email": userEmail,
        "user_name": userName,
        "user_country": userCountry,
        "user_city": userCity,
        "user_city_name": userCityName,
        "user_country_name": userCountryName,
        "user_photo": userPhoto,
        "user_show": userShow,
        "user_type": userType,
        "user_fash_number": userFashNumber,
        "user_fash_adress": userFashAdress,
    };
}