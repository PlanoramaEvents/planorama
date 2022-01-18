import Counter from './test-demo';
import { mount } from '@vue/test-utils';

describe('Counter', () => {
  let counter;
  beforeEach(() => {
    counter = mount(Counter);
  })

  it('increments counter value on click', async() => {
    const button = counter.find('button');
    const text = counter.find('p')
    expect(text.text()).toContain('Total clicks: 0')
    await button.trigger('click')
    expect(text.text()).toContain('Total clicks: 1')
  })
})
