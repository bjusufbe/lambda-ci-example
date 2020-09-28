// convert data to yaml just for the purpose of using dependency
const yaml = require('js-yaml');

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

    public outputDataInYamlFormat() {
        let data = {
            firstName: this.firstName,
            lastName: this.lastName,
            age: this.age
        }
        console.dir(yaml.safeDump(data), { colors: true });
    }
}