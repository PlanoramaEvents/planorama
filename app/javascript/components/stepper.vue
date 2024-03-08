<template>
  <div class="stepper">
    <div class="shishkabob">
      <div class="buttons">
        <button class="btn btn-secondary py-4 px-5 selected">Before Draft Publish</button>
        <button class="btn btn-secondary py-4 px-5">After Draft Publish</button>
      </div>
    </div>
    <div class="content">
      I am content
    </div>
  </div>
</template>

<script>
export default {
  name: "Stepper"
}
</script>

<style lang="sass" scoped>
.stepper {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.content {
  border: 2px solid red;
  width: 100%;
  height: 200px;
}

.shishkabob {
  width: 62.5%;
  margin-bottom: 1rem;
  .buttons {
    display: flex;
    justify-content: space-around;

    .btn-secondary {
      border-color: #ccb5f0;
      background: #ccb5f0;
      color: black;

      &:hover {
        border-color: #53269f;
      }
      
      &.selected {
        border-color: #53269f;
        background: #53269f;
        color: white;
      }
    }
  }

  &:before {
    content: '';
    border: 4px solid #ccb5f0;
    height: 0;
    width: 100%;
    text-align: center;
    position: relative;
    top: 38px;
    display: block;
    z-index: -1;
  }

}

</style>
