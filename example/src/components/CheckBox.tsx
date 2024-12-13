import React from 'react'
import {
  Image,
  StyleSheet,
  TouchableOpacity,
  TouchableOpacityProps,
} from 'react-native'
import images from '../assets'
import useTheme from '../hook/useTheme'

interface CheckBoxProps extends TouchableOpacityProps {
  checked?: boolean
  onChecked?: (checked: boolean) => void
}

export function CheckBox({
  checked = false,
  onChecked,
  ...props
}: CheckBoxProps) {
  const { foreground, background_2 } = useTheme()

  return (
    <TouchableOpacity
      activeOpacity={0.9}
      onPress={() => onChecked?.(!checked)}
      {...props}
      style={[
        style.container,
        props.style,
        {
          backgroundColor: checked ? foreground : background_2,
          borderColor: foreground + '64',
        },
      ]}
    >
      {checked && (
        <Image
          style={[style.check, { tintColor: background_2 }]}
          source={images.check}
        />
      )}
    </TouchableOpacity>
  )
}

const style = StyleSheet.create({
  container: {
    width: 24,
    height: 24,
    alignItems: 'center',
    justifyContent: 'center',
    borderRadius: 4,
  },
  check: {
    width: 16,
    height: 16,
  },
})
