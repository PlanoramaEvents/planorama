import { shallowMount, createLocalVue } from '@vue/test-utils'
import Vuex from 'vuex'
import VuexExample from './vuex-example';
import { jest } from '@jest/globals';


describe('Actions', () => {
  let store, actions, getters;
  let underTest;
  let localVue;

  beforeEach(() => {
    localVue = createLocalVue()
    localVue.use(Vuex);
    actions = {
      actionClick: jest.fn(),
      actionInput: jest.fn()
    }

    getters = {
      clicks: () => 2,
      inputValue: () => 'input'
    }

    store = new Vuex.Store({
      actions,
      getters
    })

    underTest = shallowMount(VuexExample, {store, localVue})
  })

  describe('Actions', () => {
    it('dispatches "actionInput" when input event value is "input"', () => {
      const input = underTest.find('input')
      input.element.value = 'input'
      input.trigger('input')
      expect(actions.actionInput).toHaveBeenCalled()
    })

    it('does not dispatch "actionInput" when event value is not "input"', () => {
      const input = underTest.find('input')
      input.element.value = 'not input';
      input.trigger('input')
      expect(actions.actionInput).not.toHaveBeenCalled();
    })

    it('calls store action "actionClick" when button is clicked', () => {
      underTest.find("button").trigger('click')
      expect(actions.actionClick).toHaveBeenCalled();
    })
  })

  describe( 'Getters', () => {
    it('Renders "store.getters.inputValue in first p tag', () => {
      const p = underTest.find('p')
      expect(p.text()).toBe(getters.inputValue())
    })

    it('Renders "store.getters.clicks" in second p tag', () => {
      const p = underTest.findAll('p').at(1)
      expect(p.text()).toBe(getters.clicks().toString());
    })
  })
})
