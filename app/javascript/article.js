import $ from 'jquery'
import axios from 'axios'
import Rails from "@rails/ujs"

axios.defaults.headers.common['X-CSRF-Token'] = Rails.csrfToken()

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

    axios.get(`/articles/${articleId}/like`)
    .then((res) => {
      const hasLiked = res.data.hasLiked
      handleHeartDisplay(self, hasLiked)
    })
  })

})
