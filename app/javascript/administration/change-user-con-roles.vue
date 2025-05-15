<template>
  <div>
    <combo-box
      :options='options'
      v-bind:select-size="4"
      :loading="loading"
      @change="onChange"
    ></combo-box>

    <!-- TODO: change to passing in the id of the person instead of the actual person -->
    <user-convention-role model="person" :person-id="selectedId" v-if="selectedId"></user-convention-role>
  </div>
</template>

<script>
import UserConventionRole from './user-convention-role.vue'
import ComboBox from '@/components/combo_box'
import modelMixin from '@/store/model.mixin';

export default {
  name: "ChangeUserConventionRoles",
  components: {
    UserConventionRole,
    ComboBox
  },
  data () {
    return {
      options: [],
      data: [],
      loading: true,
      selectedId: null
    }
  },
  mixins: [
    modelMixin
  ],
  watch: {
    data(newVal, oldVal) {
      if (newVal) {
        this.options = Object.values(newVal).filter(
          obj => (typeof obj.json === 'undefined')
        ).map(
          obj => (
            {
              value: obj.id,
              text: obj['name']
            }
          )
        )
      } else {
        this.options = []
      }
    }
  },
  methods: {
    onChange(arg) {
      this.selectedId = arg
    },
    load_people_combo() {
      this.loading = true
      this.selectedId = null
      this.search({
        "fields[person]": "id,name",
        "sortBy": 'name',
        "sortOrder": 'asc',
        "perPage": 10000
      }).then(data => {
        this.data = data
        this.loading = false
      })
    },
    init() {
      this.load_people_combo()
    }
  }
}
</script>

<style lang="scss" scoped>
</style>
