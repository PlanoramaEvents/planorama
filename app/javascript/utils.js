export async function validateFields(...fields) {
    const promises = fields.map(f => {
        return new Promise((res, rej) => {
            f.validate = res
        });
    });
    return Promise.all(promises)
}
