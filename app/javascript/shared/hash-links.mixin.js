export const hashLinksMixin = {
  methods: {
    scrollFix: function(hashbang) {
      location.hash = hashbang;
    }
  }
}

export default hashLinksMixin;
