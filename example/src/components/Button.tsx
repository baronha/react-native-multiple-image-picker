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
}

export function Button({ children, style: containerStyle, onPress }: Props) {
  const { foreground, background } = useTheme()

  return (
    <TouchableOpacity
      style={[style.button, containerStyle, { backgroundColor: foreground }]}
      onPress={onPress}
    >
      {typeof children === 'string' ? (
        <Text style={{ color: background }}>{children}</Text>
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
  },
})
