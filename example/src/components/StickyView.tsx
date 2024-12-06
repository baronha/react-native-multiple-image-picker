import React from 'react'

import Animated, {
  Extrapolation,
  interpolate,
  SharedValue,
  useAnimatedStyle,
} from 'react-native-reanimated'
import { HALF_HEIGHT } from '../theme/size'
import { Result } from '@baronha/react-native-multiple-image-picker'
import { Row } from './Row'
import { Image, StyleSheet } from 'react-native'
import { IS_IOS } from '../common/const'
import { colors } from '../theme/color'

export function StickyView({
  scrollY,
  images,
  ...props
}: {
  scrollY: SharedValue<number>
  images: Result[]
}) {
  const stickyView = useAnimatedStyle(() => {
    return {
      borderColor: colors.divider,
      borderBottomWidth: interpolate(scrollY.value, [0, HALF_HEIGHT], [0, 1], {
        extrapolateRight: Extrapolation.CLAMP,
      }),
    }
  })

  return (
    <Animated.View {...props} style={[style.container, stickyView]}>
      {images.length ? (
        <Row style={style.row} gap={4}>
          {[...images].slice(0, 5).map((image) => (
            <Image
              source={{
                uri: `${IS_IOS ? 'file://' : ''}${image.path}`,
              }}
              style={style.image}
            />
          ))}
        </Row>
      ) : null}
    </Animated.View>
  )
}

const style = StyleSheet.create({
  container: {
    // position: 'absolute',
  },
  image: {
    flex: 1 / 6,
    aspectRatio: 1,
  },
  row: {},
})
