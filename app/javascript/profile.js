import $ from 'jquery'
import axios from 'modules/axios'

document.addEventListener('turbo:load', () => {

  // アバター画像を取得して表示
  const avatarImageUrl = $('#profile-avatar').data('avatarImageUrl')
  $('.avatar').append(
    `<img class='avatar_image avatar_l' src=${avatarImageUrl}>`
  )

  // 変更されたアバター画像をサーバーに送り、画面上の画像を更新
  $('.input_avatar').on('change', function() {

    const file = this.files[0]

    if (!file) {
      window.alert('画像を選択してください')
      return
    }

    const formData = new FormData($('#avatar_form')[0])

    axios.put('/profile', formData, {
      headers: {
        'Content-Type': 'multipart/form-data'
      }
    })

    .then(res => {
      const newAvatar = res.data.avatar_url

      if (newAvatar) {
      $('.avatar_image').attr('src', newAvatar)
      window.alert('画像の更新に成功しました')
      }
    })
    .catch(e => {
      console.log(e)
      window.alert('画像の更新に失敗しました')
    })
  })
})
