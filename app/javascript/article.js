import $ from 'jquery'
import axios from 'axios'
import Rails from "@rails/ujs"

axios.defaults.headers.common['X-CSRF-Token'] = Rails.csrfToken()

document.addEventListener('turbo:load', () => {

  // いいねの状態を取得してハートを表示
  $('.article').each(function() {

    const articleId = $(this).data('articleId')

    axios.get(`/articles/${articleId}/like`)
    .then((res) => {

      const hasLiked = res.data.hasLiked
      const activeHeart = $(this).find('.active-heart')
      const inactiveHeart = $(this).find('.inactive-heart')

      if (hasLiked) {
        activeHeart.removeClass('hidden')
      } else {
        inactiveHeart.removeClass('hidden')
      }
    })
  })

})
