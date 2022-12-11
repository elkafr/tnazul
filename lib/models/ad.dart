
class Ad {
    Ad({
        this.adsId,
        this.adsTitle,
        this.adsUrl,
        this.adsDate,
        this.adsAge,
        this.adsFullDate,
        this.adsVisits,
        this.adsCat,
        this.adsCatName,
        this.adsCatImage,
        this.adsSub,
        this.adsSubCatName,
        this.adsCatUrl,
        this.adsCountry,
        this.adsCountryName,
        this.adsCountryUrl,
        this.adsCityName,
        this.adsMarka,
        this.adsMarkaName,
        this.adsMarkaUrl,
        this.adsType,
        this.adsTypee,
        this.adsTypeName,
        this.adsTypeUrl,
        this.adsModel,
        this.adsModelName,
        this.adsModelUrl,
        this.adsUser,
        this.adsUserName,
        this.adsUserUrl,
        this.adsPhoto,
        this.adsDetails,
        this.adsPrice,
        this.adsPhone,
        this.adsRate,
        this.adsAdress,
        this.adsLocation,

        this.adsCylinders,
        this.adsDvd,
        this.adsOutColor,
        this.adsOpenRoof,
        this.adsFuel,
        this.adsCamera,
        this.adsGear,
        this.adsGuarantee,
        this.adsSpeedometer,
        this.adsPropulsion,
        this.adsSensors,
        this.adsCd,
        this.adsBluetooth,
        this.adsInColor,
        this.adsChairsType,
        this.adsGps,

        this.adsJob,
        this.adsFrom,
        this.adsYears,
        this.adsEducation,
        this.adsPhone1,
        this.adsBenefit,
        this.adsWhatsapp,

        this.adsIsFavorite,
    });

    String adsId;
    String adsTitle;
    String adsUrl;
    String adsDate;
    String adsAge;
    String adsFullDate;
    String adsVisits;
    String adsCat;
    String adsCatName;
    String adsCatImage;
    String adsSub;
    String adsSubCatName;
    String adsCatUrl;
    String adsCountry;
    String adsCountryName;
    String adsCountryUrl;
    String adsCityName;
    String adsMarka;
    String adsMarkaName;
    String adsMarkaUrl;
    String adsType;
    String adsTypee;
    String adsTypeName;
    String adsTypeUrl;
    String adsModel;
    String adsModelName;
    String adsModelUrl;
    String adsUser;
    String adsUserName;
    String adsUserUrl;
    String adsPhoto;
    String adsDetails;
    String adsPrice;
    String adsPhone;
    String adsRate;
    String adsAdress;
    String adsLocation;

    String adsCylinders;
    String adsDvd;
    String adsOutColor;
    String adsOpenRoof;
    String adsFuel;
    String adsCamera;
    String adsGear;
    String adsGuarantee;
    String adsSpeedometer;
    String adsPropulsion;
    String adsSensors;
    String adsCd;
    String adsBluetooth;
    String adsInColor;
    String adsChairsType;
    String adsGps;

    String adsJob;
    String adsFrom;
    String adsYears;
    String adsEducation;
    String adsPhone1;
    String adsBenefit;
    String adsWhatsapp;


    int adsIsFavorite;

    factory Ad.fromJson(Map<String, dynamic> json) => Ad(
        adsId: json["ads_id"],
        adsTitle: json["ads_title"],
        adsUrl: json["ads_url"],
        adsDate: json["ads_date"],
        adsAge: json["ads_age"],
        adsFullDate: json["ads_full_date"],
        adsVisits: json["ads_visits"],
        adsCat: json["ads_cat"],
        adsCatName: json["ads_cat_name"],
        adsCatImage: json["ads_cat_image"],
        adsSub: json["ads_sub"],
        adsSubCatName: json["ads_sub_cat_name"],
        adsCatUrl: json["ads_cat_url"],
        adsCountry: json["ads_country"],
        adsCountryName: json["ads_country_name"],
        adsCountryUrl: json["ads_country_url"],
        adsCityName: json["ads_city_name"],
        adsMarka: json["ads_marka"],
        adsMarkaName: json["ads_marka_name"],
        adsMarkaUrl: json["ads_marka_url"],
        adsType: json["ads_type"],
        adsTypee: json["ads_typee"],
        adsTypeName: json["ads_type_name"],
        adsTypeUrl: json["ads_type_url"],
        adsModel: json["ads_model"],
        adsModelName: json["ads_model_name"],
        adsModelUrl: json["ads_model_url"],
        adsUser: json["ads_user"],
        adsUserName: json["ads_user_name"],
        adsUserUrl: json["ads_user_url"],
        adsPhoto: json["ads_photo"],
        adsDetails: json["ads_details"],
        adsPrice: json["ads_price"],
        adsPhone: json["ads_phone"],
        adsRate: json["ads_rate"],
        adsAdress: json["ads_adress"],
        adsLocation: json["ads_location"],

        adsCylinders: json["ads_cylinders"],
        adsDvd: json["ads_dvd"],
        adsOutColor: json["ads_out_color"],
        adsOpenRoof: json["ads_open_roof"],
        adsFuel: json["ads_fuel"],
        adsCamera: json["ads_camera"],
        adsGear: json["ads_gear"],
        adsGuarantee: json["ads_guarantee"],
        adsSpeedometer: json["ads_speedometer"],
        adsPropulsion: json["ads_propulsion"],
        adsSensors: json["ads_sensors"],
        adsCd: json["ads_cd"],
        adsBluetooth: json["ads_bluetooth"],
        adsInColor: json["ads_in_color"],
        adsChairsType: json["ads_chairs_type"],
        adsGps: json["ads_gps"],

        adsJob: json["ads_job"],
        adsFrom: json["ads_from"],
        adsYears: json["ads_years"],
        adsEducation: json["ads_education"],
        adsPhone1: json["ads_phone1"],
        adsBenefit: json["ads_benefit"],
        adsWhatsapp: json["ads_whatsapp"],


        adsIsFavorite: json["ads_is_favorite"],
    );

    Map<String, dynamic> toJson() => {
        "ads_id": adsId,
        "ads_title": adsTitle,
        "ads_url": adsUrl,
        "ads_date": adsDate,
        "ads_age": adsAge,
        "ads_full_date": adsFullDate,
        "ads_visits": adsVisits,
        "ads_cat": adsCat,
        "ads_cat_name": adsCatName,
        "ads_cat_image": adsCatImage,
        "ads_sub": adsSub,
        "ads_sub_cat_name": adsSubCatName,
        "ads_cat_url": adsCatUrl,
        "ads_country": adsCountry,
        "ads_country_name": adsCountryName,
        "ads_country_url": adsCountryUrl,
        "ads_city_name": adsCityName,
        "ads_marka": adsMarka,
        "ads_marka_name": adsMarkaName,
        "ads_marka_url": adsMarkaUrl,
        "ads_type": adsType,
        "ads_typee": adsTypee,
        "ads_type_name": adsTypeName,
        "ads_type_url": adsTypeUrl,
        "ads_model": adsModel,
        "ads_model_name": adsModelName,
        "ads_model_url": adsModelUrl,
        "ads_user": adsUser,
        "ads_user_name": adsUserName,
        "ads_user_url": adsUserUrl,
        "ads_photo": adsPhoto,
        "ads_details": adsDetails,
        "ads_price": adsPrice,
        "ads_phone": adsPhone,
        "ads_rate": adsRate,
        "ads_adress": adsAdress,
        "ads_location": adsLocation,

        "ads_cylinders": adsCylinders,
        "ads_dvd": adsDvd,
        "ads_out_color": adsOutColor,
        "ads_open_roof": adsOpenRoof,
        "ads_fuel": adsFuel,
        "ads_camera": adsCamera,
        "ads_gear": adsGear,
        "ads_guarantee": adsGuarantee,
        "ads_speedometer": adsSpeedometer,
        "ads_propulsion": adsPropulsion,
        "ads_sensors": adsSensors,
        "ads_cd": adsCd,
        "ads_bluetooth": adsBluetooth,
        "ads_in_color": adsInColor,
        "ads_chairs_type": adsChairsType,
        "ads_gps": adsGps,

        "ads_job": adsJob,
        "ads_from": adsFrom,
        "ads_years": adsYears,
        "ads_education": adsEducation,
        "ads_phone1": adsPhone1,
        "ads_benefit": adsBenefit,
        "ads_whatsapp": adsWhatsapp,


        "ads_is_favorite": adsIsFavorite,
    };
}
