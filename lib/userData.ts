export class UserData {
    protected firstName: string;
    protected lastName: string;
    protected age: Number;

    constructor(firstName: string, lastName: string, age: Number) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.age = age;
    }

    public getUserDataInfo() {
        return `First name: ${this.firstName}, Last name: ${this.lastName}, Age: ${this.age}`
    }
}