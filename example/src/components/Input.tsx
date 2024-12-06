import React from 'react'
import { StyleSheet, TextInput, TextInputProps } from 'react-native'
import useTheme from '../hook/useTheme'

export function Input({ ...props }: TextInputProps) {
  const { background_2, foreground } = useTheme()

  return (
    <TextInput
      {...props}
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
    paddingVertical: 4,
    borderRadius: 4,
    fontSize: 16,
  },
})
