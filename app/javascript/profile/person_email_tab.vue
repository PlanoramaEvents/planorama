<template>
  <div class="container-fluid">
    <div class="row">
      <div class="col">
        <div v-for="mail in fetchedMailings" :key="mail.id" class="mb-2">
          <h5> {{DateTime.fromISO(mail.date_sent).toFormat("DDDD, t ZZZZ")}} </h5>
          <dl>
            <dt class="font-weight-bold">Subject</dt>
            <dd class="ml-2">{{mail.subject}}</dd>
            <dt class="font-weight-bold">Body</dt>
            <dd class="ml-2" v-html="mail.content"></dd>
          </dl>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { DateTime } from 'luxon';
import { mapActions } from 'vuex';
import { personModel as model } from '@/store/person.store';
import { modelMixinNoProp } from '@/mixins';

export default {
  name: 'PersonEmailTab',
  data: () => ({
    fetchedMailings: [],
    DateTime,
    model,
  }),
  mixins: [
    modelMixinNoProp
  ],
  methods: {
    ...mapActions({
      get: 'jv/get'
    }),
    fetchMailings() {
      this.get(`/person/${this.selected.id}/mail_histories`).then((data) => {
          let {_jv, ...filteredMailings} = data;
          let sortableMailings = Object.values(filteredMailings);
          sortableMailings.sort((a, b) => DateTime.fromISO(b.date_sent) - DateTime.fromISO(a.date_sent));
          this.fetchedMailings = sortableMailings
      });
    }
  },
  watch: {
    selected(newVal, oldVal) {
      if(newVal && newVal?.id !== oldVal?.id) {
        this.fetchMailings();
      }
    }
  },
  mounted() {
    if (this.selected) {
      this.fetchMailings();
    }
  },

}
</script>

<style>

</style>
