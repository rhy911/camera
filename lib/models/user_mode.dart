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
        json['Address'] != null ? new Address.fromJson(json['Address']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['FirstName'] = this.firstName;
    data['LastName'] = this.lastName;
    data['DateOfBirth'] = this.dateOfBirth;
    if (this.address != null) {
      data['Address'] = this.address!.toJson();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['HouseNumber'] = this.houseNumber;
    data['Street'] = this.street;
    data['State'] = this.state;
    data['ZipCode'] = this.zipCode;
    data['Country'] = this.country;
    return data;
  }
}
