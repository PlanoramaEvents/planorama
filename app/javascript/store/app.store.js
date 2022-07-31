export const MAGICAL_RELOAD = 'MAGICAL RELOAD'
export const SET_PER_PAGE = 'SET PER PAGE';

export const appStore = {
  state: {
    magicalReload: 0,
    reloadedAt: new Date(),
    perPage: 20
  },
  mutations: {
    [MAGICAL_RELOAD] (state) {
      state.magicalReload += 1;
      state.reloadedAt = new Date();
    },
    [SET_PER_PAGE] (state, amt) {
      state.perPage = amt;
    }
  }
}
