import React from 'react'
import {
  StyleSheet,
  TouchableOpacity,
  TouchableOpacityProps,
} from 'react-native'
import useTheme from '../hook/useTheme'
import { Text } from './Text'

interface Props extends TouchableOpacityProps {
  children: React.ReactNode | string
  type?: 'full' | 'outline'
}

export function Button({
  children,
  style: containerStyle,
  onPress,
  type = 'full',
}: Props) {
  const { foreground, background } = useTheme()
  const isFull = type === 'full'

  return (
    <TouchableOpacity
      style={[
        style.button,
        containerStyle,
        // eslint-disable-next-line react-native/no-inline-styles
        {
          backgroundColor: isFull ? foreground : 'transparent',
          borderColor: isFull ? 'transparent' : foreground,
        },
      ]}
      onPress={onPress}
    >
      {typeof children === 'string' ? (
        <Text style={[style.text, { color: isFull ? background : foreground }]}>
          {children}
        </Text>
      ) : (
        children
      )}
    </TouchableOpacity>
  )
}

const style = StyleSheet.create({
  button: {
    padding: 12,
    alignItems: 'center',
    borderWidth: 1.5,
  },
  text: {
    fontFamily: 'Avenir',
    fontWeight: 'bold',
  },
})
