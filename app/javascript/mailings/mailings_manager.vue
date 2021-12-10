<template>
  <div>
    <combo-box
      :options='options'
      v-bind:select-size="4"
    ></combo-box>
  </div>
</template>

<script>
import ComboBox from '../components/combo_box';
import modelMixin from '../store/model.mixin';

export default {
  name: "MailingsManager",
  components: {
    ComboBox
  },
  data () {
    return {
      options: [],
      data: []
    }
  },
  props: {
    attribute: String
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
              text: obj[this.attribute]
            }
          )
        )
      } else {
        this.options = []
      }
    }
  },
  methods: {
    init() {
      // TODO: optimize by putting in field filter
      this.search({}).then(data => {this.data = data})
    }
  }
}
</script>

<style>

</style>
