class UserModel {
  String? id;
  String? firstName;
  String? lastName;
  String? dateOfBirth;
  Address? address;

  UserModel(
      {this.id, this.firstName, this.lastName, this.dateOfBirth, this.address});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    firstName = json['FirstName'];
    lastName = json['LastName'];
    dateOfBirth = json['DateOfBirth'];
    address =
        json['Address'] != null ? Address.fromJson(json['Address']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['FirstName'] = firstName;
    data['LastName'] = lastName;
    data['DateOfBirth'] = dateOfBirth;
    if (address != null) {
      data['Address'] = address!.toJson();
    }
    return data;
  }
}

class Address {
  String? houseNumber;
  String? street;
  String? state;
  String? zipCode;
  String? country;

  Address(
      {this.houseNumber, this.street, this.state, this.zipCode, this.country});

  Address.fromJson(Map<String, dynamic> json) {
    houseNumber = json['HouseNumber'];
    street = json['Street'];
    state = json['State'];
    zipCode = json['ZipCode'];
    country = json['Country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['HouseNumber'] = houseNumber;
    data['Street'] = street;
    data['State'] = state;
    data['ZipCode'] = zipCode;
    data['Country'] = country;
    return data;
  }
}
