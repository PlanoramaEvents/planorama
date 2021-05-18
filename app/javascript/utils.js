export async function validateFields(...fields) {
    const promises = fields.map(f => {
        return new Promise((res, rej) => {
            f.validate = res
        });
    });
    return Promise.all(promises)
}

import Vue from 'vue';
import RenderString from './render_string.vue'
export function renderString(template, data) {
    const ComponentClass = Vue.extend(RenderString);
    const instance = new ComponentClass({
        propsData: { string: template, data }
    });
    instance.$mount()
    return instance
}
