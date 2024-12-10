import React from 'react'
import { StyleSheet, TextInput, TextInputProps } from 'react-native'
import useTheme from '../hook/useTheme'

interface InputProps extends TextInputProps {}

export function Input({ ...props }: InputProps) {
  const { background_2, foreground } = useTheme()

  return (
    <TextInput
      {...props}
      selectionColor={foreground}
      placeholderTextColor={foreground + '92'}
      style={[
        style.input,
        { backgroundColor: background_2, color: foreground },
      ]}
    />
  )
}

const style = StyleSheet.create({
  input: {
    paddingHorizontal: 12,
    paddingVertical: 12,
    borderRadius: 8,
    fontSize: 16,
  },
})
