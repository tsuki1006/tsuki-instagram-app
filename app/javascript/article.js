import $ from 'jquery'
import axios from 'modules/axios'
import {
  listenInactiveHeartEvent,
  listenActiveHeartEvent
} from 'modules/handle_heart'

const handleHeartDisplay = (el, hasLiked) => {

  const activeHeart = $(el).find('.active-heart')
  const inactiveHeart = $(el).find('.inactive-heart')

  if (hasLiked) {
    activeHeart.removeClass('hidden')
  } else {
    inactiveHeart.removeClass('hidden')
  }
}

document.addEventListener('turbo:load', () => {

  // いいねの状態を取得してハートを表示
  $('.article').each(function() {

    const self = this
    const articleId = $(this).data('articleId')

    axios.get(`/api/articles/${articleId}/like`)
    .then((res) => {
      const hasLiked = res.data.hasLiked
      handleHeartDisplay(self, hasLiked)
    })
    .catch((e) => {
      if (e.status === 401) {
        $(self).find('.inactive-heart').removeClass('hidden')
      } else {
        console.log(e)
      }
    })
  })

  // いいねする
  listenInactiveHeartEvent()
  // いいねを外す
  listenActiveHeartEvent()

})
