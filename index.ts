import { UserData } from "./lib/userData";

export const handler = async (event: any = {}): Promise<any> => {
    let userData = new UserData(event.firstName, event.lastName, event.age);
    userData.outputDataInYamlFormat();
    const response = JSON.stringify(`Hello from Lambda! User data: ${userData.getUserDataInfo()}`);
    return response;
}
