declare global {
    namespace NodeJS {
        interface ProcessEnv extends Env {
            NODE_ENV: "development" | "production" | "test" | "uat"
        }
    }
}

export { }
export type IEnv = Env
