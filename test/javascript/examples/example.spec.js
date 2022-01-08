import { mount } from '@vue/test-utils';

const MessageComponent = {
  template: '<p>{{ msg }}</p>',
  props: ['msg']
}

test('displays message', () => {
  const wrapper = mount(MessageComponent, {
    propsData: {
      msg: 'hello world'
    }
  })

  expect(wrapper.text()).toContain('hello world');
})
