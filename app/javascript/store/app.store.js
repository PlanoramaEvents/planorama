export const MAGICAL_RELOAD = 'MAGICAL RELOAD'
export const SET_PER_PAGE = 'SET PER PAGE';
export const SET_SPINNER = 'SET SPINNER';
export const SET_RELOADED_AT = 'SET RELOADED AT'

export const appStore = {
  state: {
    magicalReload: 0,
    reloadedAt: new Date(),
    perPage: 20,
    wholePageSpinner: false,
  },
  mutations: {
    [MAGICAL_RELOAD] (state) {
      state.magicalReload += 1;
      state.reloadedAt = new Date();
    },
    [SET_PER_PAGE] (state, amt) {
      state.perPage = amt;
    },
    [SET_SPINNER] (state, spinner) {
      state.wholePageSpinner = spinner;
    },
    [SET_RELOADED_AT] (state) {
      state.reloadedAt = new Date();
    }
  }
}
