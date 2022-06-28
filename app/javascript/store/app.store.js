export const MAGICAL_RELOAD = 'MAGICAL RELOAD'

export const appStore = {
  state: {
    magicalReload: 0,
    reloadedAt: new Date(),
  },
  mutations: {
    [MAGICAL_RELOAD] (state) {
      state.magicalReload += 1;
      state.reloadedAt = new Date();
    }
  }
}
